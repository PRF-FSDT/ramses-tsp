import "@typespec/http";

import "./models.tsp";
import "./common.tsp";

using TypeSpec.Http;

namespace RamsesService;

// Aliases:
alias OrderTaskType = "preparation" | "finalisation";

model OrderTaskFilterRequest {
  ...PaginatedSortableRequest;
  @query type?: OrderTaskType;
}

model OrderTaskBody {
  order_id: uint64;
  type: OrderTaskType;
  title: string;
  should_be_planned: boolean;
  is_required_for_production: boolean;
  is_external: boolean;
  is_finished: boolean;
  dependant_on: Array<integer>;
  time_registration_code_id?: numeric | null;
  time_registration_code_title?: string | null;
  order_name?: string | null;
  client_name?: string | null;
}

model OrderTaskUpdateBody {
  type?: OrderTaskType;
  title?: string;
  should_be_planned?: boolean;
  is_required_for_production?: boolean;
  is_external?: boolean;
  is_finished?: boolean;
  dependant_on?: Array<integer>;
  duration_in_min?: numeric | null;
  planned_resource_id?: numeric | null;
  time_registration_code_id?: numeric | null;
  time_registration_code_title?: string | null;
  timer_started_at?: string | null;
  elapsed_duration_in_sec?: numeric | null;

  @encode(DateTimeKnownEncoding.rfc3339)
  planned_start?: utcDateTime | null;
}

model OrderTask {
  @key id: uint64;
  order_id: integer;
  type: OrderTaskType;
  title: string;
  should_be_planned: boolean;
  is_required_for_production: boolean;
  is_external?: boolean;
  is_finished?: boolean;
  finished_by?: numeric | null;
  dependant_on?: Array<numeric> | null;
  duration_in_min?: numeric | null;
  elapsed_duration_in_sec?: numeric | null;
  due_offset_days?: numeric;
  due_date?: string | null;
  planned_resource_id?: numeric | null;
  timer_started_at?: string | null;
  time_registration_code_id?: numeric | null;
  time_registration_code_title?: string | null;
  order_name?: string | null;
  client_name?: string | null;
  order?: Order;

  @encode(DateTimeKnownEncoding.rfc3339)
  planned_start?: utcDateTime | null;

  @visibility("read") prep_start_date: string | null;
  @visibility("read") prep_end_date: string | null;
  @visibility("read") finalisation_start_date: string | null;
  @visibility("read") finalisation_end_date: string | null;
}

model OrderTaskTemplate {
  @key id: uint64;
  type: OrderTaskType;
  title: string;
  should_be_planned: boolean;
  is_required_for_production: boolean;
  is_external?: boolean;
  dependant_on?: Array<numeric> | null;
  duration_in_min?: numeric | null;
  due_offset_days?: numeric;
  time_registration_code_id?: numeric | null;
  time_registration_code_title?: string | null;
}

model OrderTaskTemplateBody {
  type: OrderTaskType;
  title: string;
  should_be_planned: boolean;
  is_required_for_production: boolean;
  is_external: boolean;
  dependant_on: Array<numeric> | null;
  duration_in_min?: numeric | null;
  due_offset_days?: numeric;
  time_registration_code_id?: numeric | null;
  time_registration_code_title?: string | null;
}

model PlannedTasksRequest {
  ...PaginatedSortableRequest;
  @query resource_id?: numeric;
  @query date?: string;
}
