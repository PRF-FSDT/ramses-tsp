import "@typespec/http";
import "@typespec/rest";
import "@typespec/openapi3";
import "@typespec/versioning";
import "./enum.tsp";

using TypeSpec.Versioning;
using TypeSpec.Http;
using TypeSpec.Rest;

namespace RamsesService;

model User {
  @key id: int64;
  name: string;
  email: string;
  role: Role;
  site_id: int64;
  site_name: string;
  created_at: utcDateTime;
  updated_at: utcDateTime;
}

model UserCreateBody {
  name: string;
  email: string;
  password: string;
  site_id: int64 | null;
  role: Role | null;
}

model UserUpdateBody {
  name: string;
  email: string;
  role?: Role;
  site_id?: int64 | null;
}
