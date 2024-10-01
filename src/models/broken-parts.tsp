/** (Broken) Planned Component **/
model BrokenPlannedComponent {
  @key id: int64;
  order_no: string;
  part_no: string;
  ncno: string;
  item_no: string | null;
  plan_pos: string | "" | null;
  broken_part_reason_id: numeric;
}


/** BrokenPartReason **/
model BrokenPartReason {
  @key id: int32;
  title: string;
}

model BrokenPartReasonBody {
  title: BrokenPartReason.title;
}
