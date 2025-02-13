import "@typespec/http";
import "./common.tsp";

using TypeSpec.Http;

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
  due_offset_days?: numeric;
  due_date?: string | null;
  planned_resource_id?: numeric | null;

  @encode(DateTimeKnownEncoding.rfc3339)
  planned_start?: utcDateTime | null;
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
}
