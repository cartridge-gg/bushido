//! Events

#[derive(Copy, Drop, Serde)]
#[dojo::event]
pub struct Follow {
    #[key]
    account_id: felt252,
    follower_id: felt252,
    time: u64,
}
