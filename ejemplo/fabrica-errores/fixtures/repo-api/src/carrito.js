// Carrito de ejemplo: calcularTotal suma precio*cantidad por línea.
//
// BUG (el error TypeError de export-muestra): si el producto de una línea
// se borró, linea.producto es null y leer .precio rompe. El paso 05 de la
// fábrica lo arregla en su rama; en main el bug sigue, y los tests de main
// solo cubren el camino sin productos borrados.
function calcularTotal(lineas) {
  return lineas.reduce((total, linea) => total + linea.producto.precio * linea.cantidad, 0);
}

module.exports = { calcularTotal };
