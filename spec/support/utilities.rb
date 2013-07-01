def it_should_be_invalid_without(variable)
	it "should be invalid without #{variable}" do
		subject.send("#{variable}=", nil)
		should be_invalid
	end
end