requires 'perl', '5.008001';

requires 'Exporter';
requires 'Contextual::Return', '0.004014';
requires 'Carp';

on 'configure' => sub {
    requires 'Module::Build::Tiny', '0.035';
};

on 'test' => sub {
    requires 'Test2::V0', '0.000135';
};

