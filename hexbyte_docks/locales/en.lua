local Translations = {
    error = {
        ["all_occupied"] = "All parking spots are occupied",
        ["not_enough"] = "Not Enough Money (%{value} required)",
    },
    success = {
        ["pay_slip"] = "You got $%{total}, your payslip %{deposit} got paid to your bank account!",
    },
    target = {
        ["talk"] = 'Talk to foreman',
    },
    menu = {
        ["header"] = "Docks Main Menu",
        ["start"] = "Start Work",
        ["start_txt"] = "Request Job Vehicle",
        ["collect"] = "Collect Paycheck",
        ["return_collect"] = "Return handler and collect paycheck here!",
    },
    help = {
        ["attach"] = "Press ~INPUT_DIVE~ to pick up this container up",
        ["detatch"] = "Press ~INPUT_DIVE~ to put down this container"
    },
    info = {
        ["deposit_paid"] = "You have paid $%{value} deposit!",
        ["started"] = "You have started working, container marked on GPS!",
        ["container_ready"] = "A new container is ready for pickup!",
        ["container_move_to_location"] = "Take this container to its assigned location"
    },
    blip = {
        ["title"] = "Container Yard",
    }
}

Lang = Lang or Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
