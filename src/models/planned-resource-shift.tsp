import "@typespec/http";
import "@typespec/rest";
import "@typespec/openapi3";
import "@typespec/versioning";

using TypeSpec.Versioning;
using TypeSpec.Http;
using TypeSpec.Rest;

namespace RamsesService;

model PlannedResourceShift {
  @key id: numeric;
  resource_id: numeric;
  resource_shift_id: numeric;
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
  resource_shift?: ResourceShift;
  planned_order_lines?: PlannedOrderLine[];
}

alias ShiftsByResource = Record<PlannedResourceShift[]>;

// date -> ShiftsByResource
alias PlannedResourceShiftsByDate = Record<ShiftsByResource>;
model PlannedResourceShiftResponse {
  @body body: PlannedShiftsByDate;
}
