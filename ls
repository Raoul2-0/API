
[1mFrom:[0m /home/manick/Documents/elearning-course-report-card-api/lib/resource_module.rb:229 ResourceModule#create:

    [1;34m207[0m: [32mdef[0m [1;34mcreate[0m
    [1;34m208[0m:   authorize @Resource [32munless[0m skip_authorization
    [1;34m209[0m:   [32mif[0m [[31m[1;31m"[0m[31mevents[1;31m"[0m[31m[0m, [31m[1;31m"[0m[31mschools[1;31m"[0m[31m[0m, [31m[1;31m"[0m[31mthemes[1;31m"[0m[31m[0m].include?(controller_name)
    [1;34m210[0m:     [32mcase[0m controller_name
    [1;34m211[0m:     [32mwhen[0m [31m[1;31m"[0m[31mevents[1;31m"[0m[31m[0m
    [1;34m212[0m:       resource = @Resource.new([35meventable[0m: @parent_model)
    [1;34m213[0m:       
    [1;34m214[0m:       resource.attributes = resource_params
    [1;34m215[0m:       resource = create_resource(resource, { [35mnested_denomination[0m: [31m[1;31m"[0m[31mphase[1;31m"[0m[31m[0m, [35mreturnResource[0m: [1;36mtrue[0m })
    [1;34m216[0m:     [32mwhen[0m [31m[1;31m"[0m[31mschools[1;31m"[0m[31m[0m, [31m[1;31m"[0m[31mthemes[1;31m"[0m[31m[0m
    [1;34m217[0m:       resource = @Resource.new(resource_params)
    [1;34m218[0m:       resource = create_resource(resource, { [35mnotInstitutionalisable[0m: [1;36mtrue[0m, [35mreturnResource[0m: [1;36mtrue[0m })
    [1;34m219[0m:     [32melse[0m
    [1;34m220[0m:       [1;34m# to be defined[0m
    [1;34m221[0m:     [32mend[0m
    [1;34m222[0m:   [32melse[0m
    [1;34m223[0m:     resource = @Resource.new(resource_params)
    [1;34m224[0m:     resource = create_resource(resource, { [35mreturnResource[0m: [1;36mtrue[0m })
    [1;34m225[0m:   [32mend[0m
    [1;34m226[0m:   
    [1;34m227[0m:   resource = @ResourceService.new(global_params).make_block(resource)
    [1;34m228[0m:   binding.pry
 => [1;34m229[0m:   render [35mjson[0m: resource, [35mstatus[0m: [33m:created[0m [32mif[0m !performed?
    [1;34m230[0m: [32mend[0m

