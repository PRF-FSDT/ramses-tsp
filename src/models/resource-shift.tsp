import "@typespec/http";
import "@typespec/rest";
import "@typespec/openapi3";
import "@typespec/versioning";

using TypeSpec.Versioning;
using TypeSpec.Http;
using TypeSpec.Rest;

namespace RamsesService;

model ResourceShift {
  @key id: numeric;
  resource_id: numeric;
  resource_name: string | null;
  day: string;
  start_time: string;
  end_time: string;
  created_at: string;
  updated_at: string;
}

model ResourceShiftBody {
  resource_id?: numeric;
  day?: string;
  start_time?: string;
  end_time?: string;
}
