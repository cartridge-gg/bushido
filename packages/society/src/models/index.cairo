//! Models

#[derive(Copy, Drop, Serde)]
#[dojo::model]
pub struct Member {
    #[key]
    id: felt252,
    role: u8,
    guild_id: u32,
    request_count: u32,
}

#[derive(Clone, Drop, Serde)]
#[dojo::model]
pub struct Guild {
    #[key]
    id: u32,
    open: bool,
    free: bool,
    member_count: u32,
    missive_count: u32,
    alliance_id: u32,
    owner: felt252,
    metadata: ByteArray,
    socials: ByteArray,
}

#[derive(Clone, Drop, Serde)]
#[dojo::model]
pub struct Alliance {
    #[key]
    id: felt252,
    open: bool,
    free: bool,
    guild_count: u32,
    owner: u32,
    metadata: ByteArray,
    socials: ByteArray,
}

#[derive(Clone, Drop, Serde)]
#[dojo::model]
pub struct Missive {
    #[key]
    id: u32,
    guild_id: u32,
    alliance_id: u32,
    content: ByteArray,
}

#[derive(Clone, Drop, Serde)]
#[dojo::model]
pub struct Request {
    #[key]
    id: u32,
    account_id: felt252,
    guild_id: u32,
    content: ByteArray,
}
