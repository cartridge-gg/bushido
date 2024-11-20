//! Models

#[derive(Clone, Drop, Serde)]
#[dojo::model]
pub struct Deployment {
    #[key]
    service: u8,
    #[key]
    project: felt252,
    owner: felt252,
    status: u8,
    tier: u8,
    config: ByteArray,
}

#[derive(Copy, Drop, Serde)]
#[dojo::model]
pub struct Factory {
    #[key]
    id: u8,
    version: felt252,
    default_version: felt252,
}

#[derive(Clone, Drop, Serde)]
#[dojo::model]
pub struct Game {
    #[key]
    project: felt252,
    owner: felt252,
    world: felt252,
    namespace: felt252,
    name: felt252,
    priority: u8,
    socials: ByteArray,
    metadata: ByteArray,
    active: bool,
}
