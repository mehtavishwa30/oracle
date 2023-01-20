library interface;

// abi declaration

abi Oracle {

    // retrieve the owner of the asset
    #[storage(read)]
    fn owner() -> Identity;

    // initialise owner
    #[storage(read, write)]
    fn initialise_owner() -> Identity;

    // update the new price of the asset in storage
    #[storage(read, write)]
    fn set_asset_price(asset_id: ContractID, price: u64);

    // retrieve latest asset price
    #[storage(read)]
    fn get_asset_price(asset_id: ContractID) -> Price;

    // check if latest price of asset has crossed order limit, withdraw funds if yes.
    #[storage(read)]
    fn order_limit(limit: u64, price: u64);

    // transfer funds of amount 'amount' back to owner
    #[storage(read, write)]
    fn withdraw_funds(amount: u64, asset_id: ContractID);

    // check remaining balance of funds
    #[storage(read)]
    fn remaining_balance(asset_id: ContractID) -> u64;
    
}