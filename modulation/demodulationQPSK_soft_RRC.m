function [m_reconstruit, ux_reconstruit, t, y_matched] = demodulationQPSK_soft_RRC(z, nus, fp, Db, A, alpha)
% Démodulation QPSK avec filtrage RRC adapté et compensation du délai

    Ts = 1/nus;
    Rs = Db/2;
    nrepet = round(nus / Rs);
    span = 6;
    delay = (span/2) * nrepet;

    % === Axe temporel ===
    t = (0:length(z)-1) * Ts;

    % === Démodulation cohérente ===
    z_I = z .* cos(2*pi*fp*t);
    z_Q = -z .* sin(2*pi*fp*t);
    y_bb = z_I + 1i*z_Q;

    % === Filtre RRC ===
    rrcFilter = rcosdesign(alpha, span, nrepet, 'sqrt');
    rrcFilter = rrcFilter / norm(rrcFilter);

    % === Filtrage adapté ===
    y_matched = conv(y_bb, rrcFilter, 'full');

    % === Compensation du délai total ===
    y_sync = y_matched(delay+1:end-delay);

    % === Échantillonnage aux instants symboles ===
    ux_reconstruit = y_sync(1:nrepet:end);

    % === Décision sur constellation ===
    phase_reconstruit = mod(angle(ux_reconstruit), 2*pi);
    nphase = round((phase_reconstruit - pi/4) / (pi/2));
    nphase = mod(nphase, 4);

    % === Mapping inverse ===
    bits = de2bi(nphase, 2, 'left-msb')';
    m_reconstruit = bits(:).'; % flatten
end