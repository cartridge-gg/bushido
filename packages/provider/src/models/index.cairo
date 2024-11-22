//! Models

#[derive(Clone, Drop, Serde)]
#[dojo::model]
pub struct Deployment {
    #[key]
    service: u8,
    #[key]
    project: felt252,
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
pub struct Team {
    #[key]
    id: felt252,
    deployment_count: u32,
    time: u64,
    name: felt252,
    description: ByteArray,
}

#[derive(Copy, Drop, Serde)]
#[dojo::model]
pub struct Teammate {
    #[key]
    team_id: felt252,
    #[key]
    time: u64,
    #[key]
    account_id: felt252,
    role: u8,
}
