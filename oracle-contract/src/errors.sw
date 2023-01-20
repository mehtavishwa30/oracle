library errors;

// init error
pub enum InitError{
    CannotReinitialise: (),
    NotInitialised: (),
    Initialised: (),
}

// transaction failed error
pub enum TransactionFailed{
    InsufficientFunds: u64;
}