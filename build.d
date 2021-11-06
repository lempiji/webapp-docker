module build;

import std;

void main()
{
    auto docker = spawnShell("docker build -t webapp --build-arg BUILD_MODE=release .",
        stdin, stdout, stderr, null, Config.none, "./app");
    auto status = docker.wait();
    if (status != 0)
    {
        stderr.writeln("Error: 'docker build' status: ", status);
        return;
    }
}