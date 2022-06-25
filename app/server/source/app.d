import vibe.vibe;
import std.conv : to;
import std.process : environment;
import std.typecons : Nullable;
import std.format : format;

void main()
{
    logInfo("Start Application Server");

    auto host = environment.get("HOST", "0.0.0.0");
    auto port = to!ushort(environment.get("PORT", "8080"));

    auto settings = new HTTPServerSettings;
    settings.port = port;
    settings.bindAddresses = [host];

    auto router = new URLRouter;
    router.get("/health", &checkHealth); // GET /health
	registerWebInterface(router, new AppServer);
	router.get("*", serveStaticFiles("public"));

    scope listener = listenHTTP(settings, router);
    scope (exit)
        listener.stopListening();

    runApplication();
}

void checkHealth(scope HTTPServerRequest, scope HTTPServerResponse res)
{
    res.writeJsonBody(["status": "healthy"], 200);
}

class AppServer
{
	void index(scope HTTPServerRequest req, scope HTTPServerResponse res)
	{
		res.redirect("/index.html");
	}

    @method(HTTPMethod.GET)
    @path("/api/data")
    void getData(scope HTTPServerRequest req, scope HTTPServerResponse res)
    {
        res.writeJsonBody(["value": 100], 200);
    }
}