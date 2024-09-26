module MyModule::TokenizedVoting {

    use aptos_framework::signer;
    use std::vector;

    /// Struct representing a proposal and the vote counts.
    struct Proposal has store, key {
        yes_votes: u64,      // Number of "Yes" votes
        no_votes: u64,       // Number of "No" votes
        voters: vector<address>,  // List of addresses that have already voted
    }

    /// Function to create a proposal for voting.
    public fun create_proposal(creator: &signer) {
        let proposal = Proposal {
            yes_votes: 0,
            no_votes: 0,
            voters: vector::empty<address>(),
        };
        move_to(creator, proposal);
    }

    /// Function to vote on a proposal (1 for "Yes", 0 for "No").
    public fun vote_on_proposal(voter: &signer, proposal_owner: address, vote: u8) acquires Proposal {
        let proposal = borrow_global_mut<Proposal>(proposal_owner);
        let voter_address = signer::address_of(voter);

        // Check if the voter has already voted
        let i = 0;
        while (i < vector::length(&proposal.voters)) {
            assert!(voter_address != *vector::borrow(&proposal.voters, i), 1); // Ensure the voter hasn't voted yet
            i = i + 1;
        };

        // Record the vote
        if (vote == 1) {
            proposal.yes_votes = proposal.yes_votes + 1;
        } else {
            proposal.no_votes = proposal.no_votes + 1;
        };

        // Add the voter to the list of voters
        vector::push_back(&mut proposal.voters, voter_address);
    }
}
