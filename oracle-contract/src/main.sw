contract;

dep data_structures;
dep errors;
dep events;
dep interface;

use data_structures::Price;
use std::{
    auth::{
        AuthError,
        msg_sender,
    },
    block::timestamp,
    identity::Identity,
    result::Result,
    revert::require,
    logging::log,
    token::transfer,
}

storage{
    prices: StorageMap<ContractID, Price> = StorageMap{},
    owner: Address = Address::from(address_zero),
    balance: StorageMap<(Identity, ContractID), u64> StorageMap{},
    limit: u64;
}

// abi implementation

impl Oracle for Contract {

    // retrieve the owner of the asset
    #[storage(read)]
    fn owner() -> Identity{
        Identity::Address(storage.owner)
    }

    // initialise owner
    #[storage(read, write)]
    fn initialise(owner: Address){
        owner = storage.owner;
    }

    // update the new price of the asset in storage
    #[storage(read, write)]
    fn set_asset_price(asset_id: ContractID, price: u64){
        storage.prices.insert(asset_id, Price{ asset_id, price , last_updated: timestamp(), });
    }

    // retrieve latest asset price
    #[storage(read)]
    fn get_asset_price(asset_id: ContractID) -> Price { storage.prices.get(asset_id) };

    // check if latest price of asset has crossed order limit, withdraw funds if yes.
    #[storage(read)]
    fn order_limit(limit: u64, price: u64){
        let current_price = storage.prices.get(asset_id);

        if current_price >= limit {
            withdraw_funds();
        }
        else {
            revert(0);
        }
    }

    // transfer funds of amount 'amount' back to owner
    #[storage(read, write)]
    fn withdraw_funds(withdrawal_amount: u64, asset_id: ContractID){
        let sender = msg_sender().unwrap();
        let current_balance = storage.balance.get(sender, asset_id);

        // throw transaction error if owner has insufficient funds for the withdrawal amount
        require(current_balance <= withdrawal_amount, TransactionFailed::InsufficientBalance(withdrawal_amount));

        // update the remaining balance after funds are withdrawn
        let remaining_balance = current_balance - withdrawal_amount;
        storage.balance.insert((sender, asset_id), remaining_balance);
        transfer(withdrawal_amount, asset_id, sender);

        log(WithdrawEvent{
            asset_id;
            withdrawal_amount;
            balance: remaining_balance;
        });
    }

    // check remaining balance of funds
    #[storage(read)]
    fn remaining_balance(asset_id: ContractID) -> u64 {
        let sender = msg_sender().unwrap();
        storage.balance.get((sender, asset_id), remaining_balance);
    }
}
