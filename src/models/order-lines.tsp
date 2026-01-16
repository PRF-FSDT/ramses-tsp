alias PlannedOrderLineStatus = "to_start" | "in-progress" | "finished" | "paused";

model PlannedOrderLine {
  @visibility(Lifecycle.Read) @key id: numeric | string;
  @visibility(Lifecycle.Read) order_id: int64;
  @visibility(Lifecycle.Read) order_no: string;
  @visibility(Lifecycle.Read) routing_code: string;
  @visibility(Lifecycle.Read) machine_type_code: string;
  @visibility(Lifecycle.Read) description: string;
  @visibility(Lifecycle.Read) client_no: string;
  @visibility(Lifecycle.Read) client_name: string;
  @visibility(Lifecycle.Read) parts_count: int64;
  @visibility(Lifecycle.Read) finished_parts_count: int64;
  @visibility(Lifecycle.Read) order_name: string;
  @visibility(Lifecycle.Read) status: PlannedOrderLineStatus;

  @encode(DateTimeKnownEncoding.rfc3339)
  @visibility(Lifecycle.Read)
  finished_at: utcDateTime | null;

  planned_mc_no: string;

  @encode(DateTimeKnownEncoding.rfc3339)
  planned_start: utcDateTime;

  planned_duration_in_min: int64;
  @visibility(Lifecycle.Read) prod_start_date?: string;
  @visibility(Lifecycle.Read) prod_end_date?: string;
  order?: {
    id: int32;
    no: string;
    prod_start_date: string;
    finalisation_start_date: string;
    name: string;
  };
}

alias PlannedOrderLineBody = UpdateableProperties<PlannedOrderLine>;
