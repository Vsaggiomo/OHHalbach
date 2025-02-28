-- ask user for parameters of Halbach
n = tonumber(prompt('How many magnets in the ring?'))
r = tonumber(prompt('What is the radius of circle? (cm)'))
s = tonumber(prompt('How big is one magnet? (cm)'))
matm = prompt('What material are the magnets? (name from FEMM materials library, example: N45)')

--calculate variables based on user input
angle = 2*PI/n 		--the angle of rotation between magnets
side = s*sqrt(2)/2	--the distance of a corner of the magnet from the center of the magnet

--create boundaries
	--add two nodes well outside of Halbach ring
mi_addnode(2*r,0)
mi_addnode(-2*r,0)

	--add first arcsegment and label with boundary condition
mi_addarc(2*r,0,-2*r,0,180,1)
mi_selectarcsegment(0,2)
mi_setsegmentprop("propname",2, 1,0,0)
mi_clearselected()

	--add second arcsegment and label with boundary condition
mi_addarc(-2*r,0,2*r,0,180,1)
mi_selectarcsegment(0,-2)
mi_setsegmentprop("propname",2, 1,0,0)
mi_clearselected()

--add a block label and define air
mi_addblocklabel(0,1.5*r)
mi_getmaterial('Air')
mi_selectlabel(0,1.5*r)
mi_setblockprop('Air',1,0,0,0,0,0)
mi_clearselected()

--start a for loop to create individual magnets
for i = n,0,-1
do
	--create label and set material
	mi_addblocklabel(r*sin(i*angle),r*cos(i*angle))
	mi_getmaterial(matm)
	mi_selectlabel(r*sin(i*angle),r*cos(i*angle))
	mi_setblockprop(matm,1,0,'',720/n*-i,0,0)
	mi_clearselected()

	--start for loop to create the 4 corners of each magnet
	for j = 1,4,1
	do
		mi_addnode(r*sin(i*angle)+side*sin(i*angle*2+j*PI/2+PI/4),r*cos(i*angle)+side*cos(i*angle*2+j*PI/2+PI/4))
	end

	--Connect the 4 corners to make a square magnet
	mi_addsegment(r*sin(i*angle)+side*sin(i*angle*2+1*PI/2+PI/4),r*cos(i*angle)+side*cos(i*angle*2+1*PI/2+PI/4),r*sin(i*angle)+side*sin(i*angle*2+2*PI/2+PI/4),r*cos(i*angle)+side*cos(i*angle*2+2*PI/2+PI/4))
	mi_addsegment(r*sin(i*angle)+side*sin(i*angle*2+2*PI/2+PI/4),r*cos(i*angle)+side*cos(i*angle*2+2*PI/2+PI/4),r*sin(i*angle)+side*sin(i*angle*2+3*PI/2+PI/4),r*cos(i*angle)+side*cos(i*angle*2+3*PI/2+PI/4))
	mi_addsegment(r*sin(i*angle)+side*sin(i*angle*2+3*PI/2+PI/4),r*cos(i*angle)+side*cos(i*angle*2+3*PI/2+PI/4),r*sin(i*angle)+side*sin(i*angle*2+4*PI/2+PI/4),r*cos(i*angle)+side*cos(i*angle*2+4*PI/2+PI/4))
	mi_addsegment(r*sin(i*angle)+side*sin(i*angle*2+4*PI/2+PI/4),r*cos(i*angle)+side*cos(i*angle*2+4*PI/2+PI/4),r*sin(i*angle)+side*sin(i*angle*2+1*PI/2+PI/4),r*cos(i*angle)+side*cos(i*angle*2+1*PI/2+PI/4))
end

--create node at center of the ring for measurement
mi_addnode(0,0)

--create mesh
mi_createmesh()
mi_showmesh()
----------- Acknowledgement --------------------------------------------------------------------------------------------------------
-- Thanks to Ernst Miltenburg for providing an example script