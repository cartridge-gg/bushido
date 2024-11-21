//! Events

#[derive(Copy, Drop, Serde)]
#[dojo::event]
pub struct Friend {
    #[key]
    account_id: felt252,
    friend_id: felt252,
    time: u64,
}
