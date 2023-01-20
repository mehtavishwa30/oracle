library events;

pub struct PriceUpdatedEvent{
    price: u64,
}

pub struct WithdrawEvent{
    asset_id: ContractID,
    withdrawal_amount: u64,
    balance: u64,
}