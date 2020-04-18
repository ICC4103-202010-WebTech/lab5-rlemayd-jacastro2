namespace :db do
  task :populate_fake_data => :environment do
    # If you are curious, you may check out the file
    # RAILS_ROOT/test/factories.rb to see how fake
    # model data is created using the Faker and
    # FactoryBot gems.
    puts "Populating database"
    # 10 event venues is reasonable...
    create_list(:event_venue, 10)
    # 50 customers with orders should be alright
    create_list(:customer_with_orders, 50)
    # You may try increasing the number of events:
    create_list(:event_with_ticket_types_and_tickets, 3)
  end
  task :model_queries => :environment do
    # Sample query: Get the names of the events available and print them out.
    # Always print out a title for your query
    puts("Query 1: Report the total number of tickets bought by a given customer.")
    result1 = Customer.find(1).tickets.count
    puts(result1)
    puts("EOQ") # End Of Query -- always add this line after a query.

    puts("Query 2: Report the total number of different events that a given customer has attended.")
    result2 = Event.joins(ticket_types: { tickets: :order}).where(orders: {customer_id: 1}).
        distinct.pluck(:name).count
    puts(result2)
    puts("EOQ") # End Of Query -- always add this line after a query.

    puts("Query 3: Names of the events attended by a given customer.")
    result3 = Event.joins(ticket_types: { tickets: :order}).where(orders: {customer_id: 1}).
        distinct.pluck(:name)
    puts(result3)
    puts("EOQ") # End Of Query -- always add this line after a query.

    puts("Query 4: Total number of tickets sold for an event.")
    result4 = Ticket.joins(ticket_type: :event).where(events: {id: 2}).count
    puts(result4)
    puts("EOQ") # End Of Query -- always add this line after a query.

    puts("Query 5: Total sales of an event.")
    result5 = TicketType.joins(:tickets, :event).where(event: 1).select("ticket_types.ticket_price").
        sum("ticket_price")
    puts(result5)
    puts("EOQ") # End Of Query -- always add this line after a query.

    puts("Query 6: The event that has been most attended by women.")
    result6 = Event.joins(ticket_types: {tickets: {order: :customer}}).where(customers: {gender:"f"}).
        group(:name).count.max
    puts(result6)
    puts("EOQ") # End Of Query -- always add this line after a query.

    puts("Query 7: The event that has been most attended by men ages 18 to 30.")
    result7 = Event.joins(ticket_types: {tickets: {order: :customer}}).
        where("customers.gender = 'm' and customers.age >= 18 and customers.age <= 30").group(:name).count.max
    puts(result7)
    puts("EOQ") # End Of Query -- always add this line after a query.

  end
end