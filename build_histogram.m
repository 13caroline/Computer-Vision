function gls = build_histogram(img_gray)

gls = linspace(0,255,256);

for i=0:255
    gls(i+1)= sum(sum(img_gray==i));
end

bar(gls)

end