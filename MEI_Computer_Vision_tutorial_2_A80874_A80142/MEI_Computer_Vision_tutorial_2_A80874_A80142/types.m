function tipos = types(sizes, Name)

if(strcmp(Name, 'coins.jpg'))
    tipos.onecent = sum(sizes < 60);
    tipos.fivecent = sum(sizes >= 60);
elseif(strcmp(Name, 'coins3.jpg'))
    tipos.fiftycent = sum(sizes >= 70);
    tipos.tentwentycent = sum(sizes >= 60 & sizes < 70) ;
    tipos.smallcent = sum(sizes < 60);
else
    tipos.oneeuro = sum(sizes < 23);
    tipos.twoeuro = sum(sizes >= 23);
end