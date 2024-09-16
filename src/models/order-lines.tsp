model PlannedOrderLine {
  @visibility("read") @key id: int64;
  @visibility("read") order_no: string;
  @visibility("read") routing_code: string;
  @visibility("read") description: string;
  @visibility("read") client_no: string;
  @visibility("read") client_name: string;
  @visibility("read") parts_count: int64;
  @visibility("read") finished_parts_count: int64;

  @encode(DateTimeKnownEncoding.rfc3339)
  @visibility("read")
  finished_at: utcDateTime | null;

  @encode(DateTimeKnownEncoding.rfc3339)
  @visibility("read")
  created_at: utcDateTime;

  @encode(DateTimeKnownEncoding.rfc3339)
  @visibility("read")
  updated_at: utcDateTime;

  planned_mc_no: string;

  @encode(DateTimeKnownEncoding.rfc3339)
  planned_start: utcDateTime;

  planned_duration_in_min: int64;
}

alias PlannedOrderLineBody = UpdateableProperties<PlannedOrderLine>;
