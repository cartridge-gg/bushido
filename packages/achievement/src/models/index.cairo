/// Models

#[derive(Clone, Drop, Serde)]
#[dojo::model]
pub struct Game {
    #[key]
    world_address: felt252,
    #[key]
    namespace: felt252,
    published: bool,
    whitelisted: bool,
    total_karma: u16,
    name: ByteArray,
    description: ByteArray,
    torii_url: ByteArray,
    image_uri: ByteArray,
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
