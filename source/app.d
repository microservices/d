import vibe.vibe;

@safe:

struct UserRequest {
    string name;
}

struct UserResponse {
    string message;
}

interface IUserApi {
    @bodyParam("req")
    UserResponse message(UserRequest req);
}

class UserService : IUserApi {
    UserResponse message(UserRequest req) {
        import std.conv : text;
        UserResponse response = {message: text("Hello ", req.name)};
        return response;
    }
}


void main()
{
    auto settings = new HTTPServerSettings;
    settings.port = 8080;
    settings.bindAddresses = ["0.0.0.0"];
    // write errors as JSON
    settings.errorPageHandler = (HTTPServerRequest req, HTTPServerResponse res,
                                 HTTPServerErrorInfo error) {
        Json errorResponse = Json(["message": Json(error.message)]);
        logInfo(error.debugMessage);
        res.writeJsonBody(errorResponse, error.code);
    };
    auto router = new URLRouter;
    router.registerRestInterface(new UserService());
    listenHTTP(settings, router);

    runApplication();
}
