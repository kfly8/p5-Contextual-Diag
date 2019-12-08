requires 'perl', '5.008001';

requires 'Exporter';
requires 'Contextual::Return';
requires 'Carp';

on 'test' => sub {
    requires 'Test2', '1.302014';
};

