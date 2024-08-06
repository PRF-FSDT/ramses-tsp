import "@typespec/http";
import "@typespec/rest";
import "@typespec/openapi3";
import "@typespec/versioning";
import "../models/models.tsp";
import "../models/users.tsp";

using TypeSpec.Versioning;
using TypeSpec.Http;
using TypeSpec.Rest;

namespace RamsesService{
  @tag("Auth")
  namespace AuthService{
    @post
    @route("/login")
    op postLogin(email: string, password: string, device_name: string): LoginResponse | Error;

    @post
    @route("/logout")
    op postLogout(): LogoutResponse | Error;

    @get
    @route("/me")
    op getMe(): MeResponse | Error;
  }
}

