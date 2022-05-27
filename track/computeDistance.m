% º∆À„SURFæÿ’Û∆•≈‰æ‡¿Î
function d = computeDistance( pts1h, pts2h, f)
pts1h(:,3) = 1;
pts2h(:,3) = 1;
pts1h = pts1h';
pts2h = pts2h';

pfp = (pts2h' * f)';
pfp = pfp .* pts1h;
d = sum(pfp, 1) .^ 2;
epl1 = f * pts1h;
epl2 = f' * pts2h;
d = d ./ (epl1(1,:).^2 + epl1(2,:).^2 + epl2(1,:).^2 + epl2(2,:).^2);
