library errors;

// user not authorised error
pub enum AccessDenied{
    UnauthorisedUser: (),
}

// init error
pub enum InitError{
    CannotReinitialise: (),
    NotInitialised: (),
    Initialised: (),
}

// transaction failed error
pub enum TransactionFailed{
    InsufficientFunds: u64,
}