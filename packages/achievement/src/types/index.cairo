/// Types

#[derive(Clone, Drop, Serde, Introspect)]
pub struct Task {
    id: felt252,
    total: u32,
    description: ByteArray,
}
