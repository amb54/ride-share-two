require_relative "spec_helper"

describe "Driver" do
  describe "#initialize" do
    it "Takes an id, name and vehicle number" do
      # id = "007"
      # name = "James Bond"
      # vin = "WBWSS52P9NEYLVDE9"
      # driver1 = RideSharing::Driver.new(id, name, vin)

      driver1 = RideSharing::Driver.new({driver_id: 007, name: "James Bond", vin: "WBWSS52P9NEYLVDE9"})
      driver1.must_respond_to :id
      driver1.id.must_equal 007

      driver1.must_respond_to :name
      driver1.name.must_equal "James Bond"

      driver1.must_respond_to :vin
      driver1.vin.must_equal "WBWSS52P9NEYLVDE9"
    end

    it "Must raise an ArgumentError if :driver_id input is not an integer > 0" do
      proc{
        RideSharing::Driver.new({driver_id: "007", name: "James Bond", vin: "WBWSS52P9NEYLVDE9"})
      }.must_raise ArgumentError

      proc{
        RideSharing::Driver.new({driver_id: -2, name: "James Bond", vin: "WBWSS52P9NEYLVDE9"})
      }.must_raise ArgumentError

      proc{
        RideSharing::Driver.new({driver_id: 11.0, name: "James Bond", vin: "WBWSS52P9NEYLVDE9"})
      }.must_raise ArgumentError

      proc{
        RideSharing::Driver.new({name: "James Bond", vin: "WBWSS52P9NEYLVDE9"})
      }.must_raise ArgumentError
    end

    it "Must raise an ArgumentError if :name is not a string" do
      proc{
        RideSharing::Driver.new({driver_id: 007, name: ["James Bond"], vin: "WBWSS52P9NEYLVDE9"})
      }.must_raise ArgumentError

      RideSharing::Driver.new({driver_id: 007, name: "[James Bond]", vin: "WBWSS52P9NEYLVDE9"}).must_be_kind_of RideSharing::Driver

      proc{
        RideSharing::Driver.new({driver_id: 007, name: "", vin: "WBWSS52P9NEYLVDE9"})
      }.must_raise ArgumentError

      proc{
        RideSharing::Driver.new({driver_id: 007, name: "  ", vin: "WBWSS52P9NEYLVDE9"})
      }.must_raise ArgumentError

      proc{
        RideSharing::Driver.new({driver_id: 007, name: "Al" , vin: "WBWSS52P9NEYLVDE9"})
      }.must_raise ArgumentError

      proc{
        RideSharing::Driver.new({driver_id: 007,  vin: "WBWSS52P9NEYLVDE9"})
      }.must_raise ArgumentError
    end

    it "Must raise an ArgumentError if :vin is not a string of 17 characters" do
      proc{
        RideSharing::Driver.new({driver_id: 007, name: "James Bond", vin: "WBWSS52P9NE"})
      }.must_raise ArgumentError

      proc{
        RideSharing::Driver.new({driver_id: 007, name: "James Bond", vin: ["WBWSS52P9NEYLVDE9"]})
      }.must_raise ArgumentError

      proc{
        RideSharing::Driver.new({driver_id: 007, name: "James Bond", vin: 42})
      }.must_raise ArgumentError
    end


  end # End of describe "Driver#initialize"


  describe "#self.all" do

    it "Returns an array." do
      path = "./support/drivers_spec1.csv"
      all_drivers = RideSharing::Driver.all(path)
      all_drivers.must_be_kind_of Array
    end

    it "The elements in the returned array must be RideSharing::Driver instances " do
      path = "./support/drivers_spec1.csv"
      all_drivers = RideSharing::Driver.all(path)
      all_drivers.each do |obj|
        obj.must_be_kind_of RideSharing::Driver
      end
      all_drivers.length.must_equal 3
    end

    it "Does not initialize driver for any of the invalid inputs in /support/drivers_spec2.csv" do
      path = "./support/drivers_spec2.csv"
      all_drivers = RideSharing::Driver.all(path)
      all_drivers.length.must_equal 14 # out of a total of 20 inputs in support/drivers_spec2.csv
      all_drivers[0].name.must_equal "Bernardo Prosacco"
      all_drivers[1].name.wont_equal "Emory Rosenbaum"
    end

    it "drivers.csv should return 100 drivers" do
      all_drivers = RideSharing::Driver.all
      all_drivers.length.must_equal 100
    end
  end # End of describe "Driver#self.all"


  describe "#self.find" do
    it "returns an object of class RideSharing::Driver if the id exists" do
      returned_object = RideSharing::Driver.find(1)
      returned_object.must_be_kind_of RideSharing::Driver
    end

    it "returns right name" do
      returned_object = RideSharing::Driver.find(1)
      returned_object.name.must_equal "Bernardo Prosacco"
      returned_object = RideSharing::Driver.find(10)
      returned_object.name.must_equal "Dr. Kenton Berge"
    end

    # it "Throws an error if id is not found" do
    #   proc{
    #     RideSharing::Driver.find(101)
    #   }.must_raise ArgumentError
    # end
    it "Returns nil if id is not found" do
      RideSharing::Driver.find(0).must_be_nil
      RideSharing::Driver.find(101).must_be_nil
    end
  end # End of describe "Driver#self.find"

  describe "#list_of_trips" do
    # This method is solely dependent upon a class method in the class Trip.
    # Blind trust is giving that no tests should be needed. The method used should have been thouroughly tested in the class Trip.
  end


  describe "#average_rating" do
    # let(:driver1) {RideSharing::Driver.new(1, "Bernardo Prosacco", "WBWSS52P9NEYLVDE9")}
    let(:driver1) {RideSharing::Driver.find(1)}
    let(:driver100) {RideSharing::Driver.find(100)}

    it "Return value should be a float" do
      driver1.average_rating.must_be_kind_of Float
    end

    it "Test of calculation of the average of the rating with number of rides > 0  " do
      sum_of_ratings = driver1.list_of_trips.map { |trip| trip.rating}.sum.to_f
      driver1.average_rating.must_equal sum_of_ratings/9
    end

    it "Test of calculation of the average of the rating with number of rides == 0  " do
      driver100 = RideSharing::Driver.find(100)
      driver100.average_rating.must_be_kind_of Float
    end
  end # End of describe "#average_rating"


################################################################################
  # describe "EXPLORING DATA" do
  #   it "Listning of ratings giving by a specific driver" do
  #     driver21 = RideSharing::Driver.find(21)
  #     driver21.list_of_trips.each do |trip|
  #       puts trip.rating
  #     end
  #   end
  #
  #   it "List of number of trips for all drivers" do
  #     RideSharing::Driver.all.each do |driver|
  #       puts "#{driver.id}: #{driver.list_of_trips.length}"
  #     end
  #   end
  #
  # end # End of describe "EXPLORING DATA"
################################################################################
end # End of describe "class Driver"
