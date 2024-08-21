import "@typespec/http";
import "@typespec/rest";
import "@typespec/openapi3";
import "@typespec/versioning";

using TypeSpec.Versioning;
using TypeSpec.Http;
using TypeSpec.Rest;

namespace RamsesService;

model RoutingCode{
  @key id: int64;
  code: string;
  name: string;
  icon: string | null;
  machine_type_code: string | null;
}

model RoutingCodeBody{
  code: string;
  name: string;
  icon: string | null;
  machine_type_code: string | null;
}

