#testing latest ubuntu ami's on terraform

Suddenly I received errors like;
~~~
* aws_instance.app-server: Error launching source instance: UnsupportedOperation: AMI 'ami-05277be2db494d1c0' with an instance-store root device is not supported for the instance type 't2.micro'.
	status code: 400, request id: 596c7558-4667-4b26-b3d3-df71e242fc15
~~~

The code I used ( and worked ) was :
~~~
data "aws_ami" "app-ami" {
  most_recent = true

  # ubuntu ami account ID
  owners = ["099720109477"]
}

This resulted in ami eu-central-1 --image-ids ami-0a6cd0a80fba6b4d0 where "RootDeviceType": "instance-store"
WIth the instance-type t2.micro this won't work.
It's crazy because last month I used it often. I can not recall which ami was selected back then.  
But still it is stupid that suddenly it doesn't work anymore.

I can not add  
~~~
root_device_type = ["ebs"]  
~~~

into the data aws_ami definition. I don't know why,  it gives an error:
~~~
Error: data.aws_ami.app-ami: "root_device_type": this field cannot be set
~~~

So the simplest solution would be not to rely anymore on only the most_recent = true attribute , but also onto a specific ubuntu version:

~~~
data "aws_ami" "app-ami" {
  most_recent = true
  # ubuntu ami account ID
owners = ["099720109477"]
filter {
  name   = "name"
  values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
}
~~~


Note: 	chosing
~~~
values = ["ubuntu/images/hvm-ssd/ubuntu-*"]
~~~
will select a xenial ( 16.04 ) ebs image.
