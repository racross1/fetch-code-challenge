class User < ApplicationRecord
    has_many :transactions
    has_many :spends
    has_many :payers, through: :transactions
   

    def get_active_transactions
        return self.transactions.select{|t| t.active_amount != 0}
    end

    def get_sorted_active_transactions
        transactions = self.get_active_transactions
        sorted = transactions.sort_by{|t| t.earn_timestamp}
        return sorted
    end 
    
    #creates hash of payer_bals with payer id as key and payer [points, name] as value
    def get_payer_bals
        activeUserTransactions = self.get_active_transactions
        payerBals = {}
        
        activeUserTransactions.each do |t|
            payer_id = t.payer_id
            payer = Payer.find(payer_id)

        if !payerBals.has_key?(payer_id)
            payerBals[payer_id] = [0, payer.name]
        end 
        payerBals[payer_id][0] += t.active_amount
    end 
        
        return payerBals
    end 

    def update_payer_bal(payer_id)
        payers = self.get_payer_bals
        
        return payers[payer_id]

    end


end
