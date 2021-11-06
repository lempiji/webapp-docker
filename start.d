module start;

import std;

void main()
{
    enum server_name = "webapp";
    enum image_name = server_name ~ ":dev";

    enum action_kill = "docker kill " ~ server_name;
    enum action_rm = "docker rm " ~ server_name;
    enum action_build = "docker build -t " ~ image_name ~ " --build-arg BUILD_MODE=debug .";
    enum action_run = "docker run -d -p 4000:4000 -e PORT=4000 --name " ~ server_name ~ " " ~ image_name;

    auto pidServer = spawnShell("dub run reloaded-vibes --"
        ~ " --watch=server/source"
        ~ " --watch=server/views"
        ~ " --action=\"" ~ action_kill ~ "\""
        ~ " --action=\"" ~ action_rm ~ "\""
        ~ " --action=\"" ~ action_build ~ "\""
        ~ " --action=\"" ~ action_run ~ "\"",
        stdin, stdout, stderr, null, Config.none, "./app");
    auto pidClient = spawnShell("npm run start", stdin, stdout, stderr, null, Config.none, "./app/client");

    pidClient.wait();
    pidServer.wait();
}
