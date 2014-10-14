cat ./test/*spec.rb > ./pkg/joint.rb
ruby ./pkg/joint.rb
rm ./pkg/joint.rb

