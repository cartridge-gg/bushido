/// Models

#[derive(Clone, Drop, Serde)]
#[dojo::model]
pub struct Access {
    #[key]
    address: felt252,
    role: u8,
}

#[derive(Clone, Drop, Serde)]
#[dojo::model]
pub struct Game {
    #[key]
    world_address: felt252,
    #[key]
    namespace: felt252,
    project: felt252,
    active: bool,
    published: bool,
    whitelisted: bool,
    priority: u8,
    karma: u16,
    metadata: ByteArray,
    socials: ByteArray,
    owner: felt252,
}

#[derive(Copy, Drop, Serde)]
#[dojo::model]
pub struct Achievement {
    #[key]
    world_address: felt252,
    #[key]
    namespace: felt252,
    #[key]
    id: felt252,
    published: bool,
    whitelisted: bool,
    karma: u16,
}
