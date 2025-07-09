model Item {
  id: numeric;
  material_no: string;
  erp_no: string | null;
  imos_no: string | null;
  name: string;
  brand: string | null;
  type: string | null;
  category_no: string | null;
  description: string | null;
  qty_in_stock: numeric;
  uom: string;
  price: numeric | string;
  length_mm: numeric | null;
  width_mm: numeric | null;
  height_mm: numeric | null;
  oversize_left_mm: numeric;
  oversize_right_mm: numeric;
  oversize_top_mm: numeric;
  oversize_btm_mm: numeric;
  cut_loss: numeric;
  grain: numeric | string | null;
  priority: numeric;
}

model ItemBody {
  id: Item.id;
  material_no: Item.material_no;
  erp_no: Item.erp_no;
  imos_no: Item.imos_no;
  name: Item.name;
  brand: Item.brand;
  type: Item.type;
  category_no: Item.category_no;
  description: Item.description;
  qty_in_stock?: Item.qty_in_stock;
  uom: Item.uom;
  price?: Item.price;
  length_mm: Item.length_mm;
  width_mm: Item.width_mm;
  height_mm: Item.height_mm;
  oversize_left_mm: Item.oversize_left_mm;
  oversize_right_mm: Item.oversize_right_mm;
  oversize_top_mm: Item.oversize_top_mm;
  oversize_btm_mm: Item.oversize_btm_mm;
  cut_loss: Item.cut_loss;
  grain: Item.grain;
  priority?: numeric;
}
