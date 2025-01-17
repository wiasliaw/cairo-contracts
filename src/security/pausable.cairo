// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts for Cairo v0.7.0 (security/pausable.cairo)

#[starknet::interface]
trait IPausable<TState> {
    fn is_paused(self: @TState) -> bool;
}

#[starknet::contract]
mod Pausable {
    use starknet::ContractAddress;
    use starknet::get_caller_address;

    #[storage]
    struct Storage {
        Pausable_paused: bool
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        Paused: Paused,
        Unpaused: Unpaused,
    }

    #[derive(Drop, starknet::Event)]
    struct Paused {
        account: ContractAddress
    }

    #[derive(Drop, starknet::Event)]
    struct Unpaused {
        account: ContractAddress
    }

    mod Errors {
        const PAUSED: felt252 = 'Pausable: paused';
        const NOT_PAUSED: felt252 = 'Pausable: not paused';
    }

    #[external(v0)]
    impl PausableImpl of super::IPausable<ContractState> {
        fn is_paused(self: @ContractState) -> bool {
            self.Pausable_paused.read()
        }
    }

    #[generate_trait]
    impl InternalImpl of InternalTrait {
        fn assert_not_paused(self: @ContractState) {
            assert(!self.Pausable_paused.read(), Errors::PAUSED);
        }

        fn assert_paused(self: @ContractState) {
            assert(self.Pausable_paused.read(), Errors::NOT_PAUSED);
        }

        fn _pause(ref self: ContractState) {
            self.assert_not_paused();
            self.Pausable_paused.write(true);
            self.emit(Paused { account: get_caller_address() });
        }

        fn _unpause(ref self: ContractState) {
            self.assert_paused();
            self.Pausable_paused.write(false);
            self.emit(Unpaused { account: get_caller_address() });
        }
    }
}
