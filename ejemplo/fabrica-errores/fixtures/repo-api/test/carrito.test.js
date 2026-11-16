const test = require("node:test");
const assert = require("node:assert/strict");
const { calcularTotal } = require("../src/carrito");

test("suma precio por cantidad", () => {
  assert.equal(calcularTotal([{ producto: { precio: 10 }, cantidad: 2 }]), 20);
});

test("carrito vacío suma 0", () => {
  assert.equal(calcularTotal([]), 0);
});
