#[derive(Copy, Drop, PartialEq)]
pub enum Role {
    None,
    Owner,
    Admin,
    Member,
}

// Implementations

impl IntoRoleU8 of core::Into<Role, u8> {
    #[inline]
    fn into(self: Role) -> u8 {
        match self {
            Role::None => 0,
            Role::Owner => 1,
            Role::Admin => 2,
            Role::Member => 3,
        }
    }
}

impl IntoU8Role of core::Into<u8, Role> {
    #[inline]
    fn into(self: u8) -> Role {
        match self {
            0 => Role::None,
            1 => Role::Owner,
            2 => Role::Admin,
            3 => Role::Member,
            _ => Role::None,
        }
    }
}
