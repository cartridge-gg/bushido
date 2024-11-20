#[derive(Copy, Drop, PartialEq)]
pub enum Service {
    None,
    Katana,
    Torii,
    Saya,
}

// Constants

pub const KATANA: felt252 = 'KATANA';
pub const TORII: felt252 = 'TORII';
pub const SAYA: felt252 = 'SAYA';
// Implementations

impl IntoServiceU8 of core::Into<Service, u8> {
    #[inline]
    fn into(self: Service) -> u8 {
        match self {
            Service::None => 0,
            Service::Katana => 1,
            Service::Torii => 2,
            Service::Saya => 3,
        }
    }
}

impl IntoU8Service of core::Into<u8, Service> {
    #[inline]
    fn into(self: u8) -> Service {
        match self {
            0 => Service::None,
            1 => Service::Katana,
            2 => Service::Torii,
            3 => Service::Saya,
            _ => Service::None,
        }
    }
}

impl IntoServiceFelt252 of core::Into<Service, felt252> {
    #[inline]
    fn into(self: Service) -> felt252 {
        match self {
            Service::None => 0,
            Service::Katana => KATANA,
            Service::Torii => TORII,
            Service::Saya => SAYA,
        }
    }
}

impl IntoFelt252Service of core::Into<felt252, Service> {
    #[inline]
    fn into(self: felt252) -> Service {
        if self == KATANA {
            Service::Katana
        } else if self == TORII {
            Service::Torii
        } else if self == SAYA {
            Service::Saya
        } else {
            Service::None
        }
    }
}
