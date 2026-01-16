import "@typespec/http";
import "@typespec/rest";
import "@typespec/openapi3";
import "@typespec/versioning";

using TypeSpec.Versioning;
using TypeSpec.Http;
using TypeSpec.Rest;

namespace RamsesService;

model PlannedMachineCenterShift {
  @key id: int64;
  machine_center_id: int64;
  machine_center_shift_id: int64;
  shift_name: string;
  shift_date: plainDate;

  @encode(DateTimeKnownEncoding.rfc3339)
  shift_start: utcDateTime;

  @encode(DateTimeKnownEncoding.rfc3339)
  shift_end: utcDateTime;

  shift_duration: integer;
  day: string;
  is_disabled: boolean;
  is_locked: boolean;
  planned_seconds: int64;
  remaining_seconds: int64;
  created_at: string;
  updated_at: string;
  machine_center?: MachineCenter;
  planned_order_lines?: PlannedOrderLine[];
}
model PlannedShiftsGroup {
  shift_date: plainDate;
  machine_center_id: int64;
  shifts: PlannedMachineCenterShift[];
}
model PlannedMachineCenterShiftResponse {
  @body body: PlannedShiftsGroup[];
}
