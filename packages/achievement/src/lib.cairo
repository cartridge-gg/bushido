mod constants;
mod store;

mod types {
    mod index;
    mod task;
}

mod models {
    mod index;
    mod game;
    mod achievement;
}

mod events {
    mod index;
    mod trophy;
    mod progress;
}

mod components {
    mod achievable;
    mod controllable;
    mod registrable;
}

#[cfg(test)]
mod tests {
    mod setup;
    mod test_achievable;
    mod test_controllable;
    mod test_registrable;

    mod mocks {
        mod achiever;
        mod controller;
        mod registrer;
    }
}
