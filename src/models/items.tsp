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
  length_mm: numeric | null;
  width_mm: numeric | null;
  height_mm: numeric | null;
  cut_loss: numeric;
  grain: string | null;
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
  //qty_in_stock: Item.qty_in_stock;
  uom: Item.uom;
  length_mm: Item.length_mm;
  width_mm: Item.width_mm;
  height_mm: Item.height_mm;
  cut_loss: Item.cut_loss;
  grain: Item.grain;
}
