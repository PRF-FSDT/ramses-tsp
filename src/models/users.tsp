import "@typespec/http";
import "@typespec/rest";
import "@typespec/openapi3";
import "@typespec/versioning";

using TypeSpec.Versioning;
using TypeSpec.Http;
using TypeSpec.Rest;

namespace RamsesService;

model User {
  @key id: int64;
  name: string;
  email: string;
  role: "user" | "planner" | "admin" | "superadmin";
}

model UserCreateBody {
  name: string;
  email: string;
  password: string;
  role?: "user" | "planner" | "admin" | "superadmin";
}

model UserUpdateBody {
  name: string;
  email: string;
  role?: "user" | "planner" | "admin" | "superadmin";
}
