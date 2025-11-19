import "@typespec/http";
import "@typespec/rest";
import "@typespec/openapi3";
import "@typespec/versioning";

using TypeSpec.Versioning;
using TypeSpec.Http;
using TypeSpec.Rest;

namespace RamsesService;

model MachineCenterShift {
  @key id: int64;
  machine_center_id: int64;
  day: string;
  start_time: string;
  end_time: string;
  created_at: string;
  updated_at: string;
}

model MachineCenterShiftBody {
  machine_center_id?: int64;
  day?: string;
  start_time?: string;
  end_time?: string;
}
