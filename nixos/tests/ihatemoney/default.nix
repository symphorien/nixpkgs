{ system ? builtins.currentSystem,
  config ? {},
  pkgs ? import ../../.. { inherit system config; }
}:

let
  inherit (import ../../lib/testing-python.nix { inherit system pkgs; }) makeTest;
  f = backend: makeTest {
    name = "ihatemoney-${backend}";
    machine = { nodes, lib, ... }: {
      services.ihatemoney = {
        enable = true;
        enablePublicProjectCreation = true;
        inherit backend;
        uwsgiConfig = {
          http = ":8000";
        };
      };
      boot.cleanTmpDir = true;
      # for exchange rates
      security.pki.certificateFiles = [ ./server.crt ];
      networking.extraHosts = "127.0.0.1 api.exchangeratesapi.io";
      services.nginx = {
        enable = true;
        virtualHosts."api.exchangeratesapi.io" = {
          addSSL = true;
          sslCertificate = ./server.crt;
          sslCertificateKey = ./server.key;
          locations."/".return = "200 '${builtins.readFile ./rates.json}'";
        };
      };
      # ihatemoney needs a local smtp server otherwise project creation just crashes
      services.opensmtpd = {
        enable = true;
        serverConfiguration = ''
          listen on lo
          action foo relay
          match from any for any action foo
        '';
      };
    };
    testScript = ''
      machine.wait_for_open_port(8000)
      machine.wait_for_unit("uwsgi.service")
      machine.wait_until_succeeds("curl https://api.exchangeratesapi.io")
      machine.wait_until_succeeds("curl http://localhost:8000")

      result = machine.succeed(
          "curl -X POST http://localhost:8000/api/projects -d 'name=yay&id=yay&password=yay&contact_email=yay@example.com&default_currency=XXX'"
      )
      assert '"yay"' in result, repr(result)
      owner, timestamp = machine.succeed(
          "stat --printf %U:%G___%Y /var/lib/ihatemoney/secret_key"
      ).split("___")
      assert "ihatemoney:ihatemoney" == owner

      with subtest("Restart machine and service"):
          machine.shutdown()
          machine.start()
          machine.wait_for_open_port(8000)
          machine.wait_for_unit("uwsgi.service")

      with subtest("check that the database is really persistent"):
          machine.succeed("curl --basic -u yay:yay http://localhost:8000/api/projects/yay")

      with subtest("check that the secret key is really persistent"):
          timestamp2 = machine.succeed("stat --printf %Y /var/lib/ihatemoney/secret_key")
          assert timestamp == timestamp2

      assert "ihatemoney" in machine.succeed("curl http://localhost:8000")
    '';
  };
in {
  ihatemoney-sqlite = f "sqlite";
  ihatemoney-postgresql = f "postgresql";
}
